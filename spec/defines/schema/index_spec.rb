require 'spec_helper'

describe 'cassandra::schema::index' do
  context 'Create a basic index' do
    let :facts do
      {
        operatingsystemmajrelease: 7,
        osfamily: 'RedHat'
      }
    end

    let(:title) { 'user_index' }

    let(:params) do
      {
        keys: 'lname',
        keyspace: 'mykeyspace',
        table: 'users'
      }
    end

    it do
      is_expected.to compile
      is_expected.to contain_cassandra__schema__index('user_index')
      is_expected.to contain_exec('/usr/bin/cqlsh   -e "CREATE INDEX IF NOT EXISTS user_index ON mykeyspace.users (lname)" localhost 9042')
    end
  end

  context 'Create a custom index.' do
    let :facts do
      {
        operatingsystemmajrelease: 7,
        osfamily: 'RedHat'
      }
    end

    let(:title) { 'user_index' }

    let(:params) do
      {
        class_name: 'path.to.the.IndexClass',
        keys: 'email',
        keyspace: 'Excelsior',
        table: 'users'
      }
    end

    it do
      is_expected.to compile
      is_expected.to contain_exec('/usr/bin/cqlsh   -e "CREATE CUSTOM INDEX IF NOT EXISTS user_index ON Excelsior.users (email) USING \'path.to.the.IndexClass\'" localhost 9042')
    end
  end
  context 'Create a custom index with options.' do
    let :facts do
      {
        operatingsystemmajrelease: 7,
        osfamily: 'RedHat'
      }
    end

    let(:title) { 'user_index' }

    let(:params) do
      {
        class_name: 'path.to.the.IndexClass',
        keys: 'email',
        keyspace: 'Excelsior',
        options: "{'storage': '/mnt/ssd/indexes/'}",
        table: 'users'
      }
    end

    it do
      is_expected.to compile
      is_expected.to contain_exec('/usr/bin/cqlsh   -e "CREATE CUSTOM INDEX IF NOT EXISTS user_index ON Excelsior.users (email) USING \'path.to.the.IndexClass\' WITH OPTIONS = {\'storage\': \'/mnt/ssd/indexes/\'}" localhost 9042')
    end
  end

  context 'Drop Index' do
    let :facts do
      {
        operatingsystemmajrelease: 7,
        osfamily: 'RedHat'
      }
    end

    let(:title) { 'user_index' }

    let(:params) do
      {
        ensure: 'absent',
        keys: 'lname',
        keyspace: 'Excelsior',
        table: 'users'
      }
    end

    it do
      is_expected.to compile
      is_expected.to contain_exec('/usr/bin/cqlsh   -e "DROP INDEX Excelsior.user_index" localhost 9042')
    end
  end

  context 'Set ensure to latest' do
    let :facts do
      {
        operatingsystemmajrelease: 7,
        osfamily: 'RedHat'
      }
    end

    let(:title) { 'foobar' }
    let(:params) do
      {
        ensure: 'latest'
      }
    end

    it { is_expected.to raise_error(Puppet::Error) }
  end
end

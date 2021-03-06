require 'spec_helper'

describe 'cassandra::schema::table' do
  context 'Create Table' do
    let :facts do
      {
        operatingsystemmajrelease: 7,
        osfamily: 'RedHat'
      }
    end

    let(:title) { 'users' }

    let(:params) do
      {
        keyspace: 'Excelsior',
        columns:
          {
            'userid' => 'text',
            'username' => 'FROZEN<fullname>',
            'emails' => 'set<text>',
            'top_scores' => 'list<int>',
            'todo' => 'map<timestamp, text>',
            'COLLECTION-TYPE' => 'tuple<int, text,text>',
            'PRIMARY KEY' => '(userid)'
          },
        options:
          [
            'COMPACT STORAGE',
            'ID=\'5a1c395e-b41f-11e5-9f22-ba0be0483c18\''
          ]
      }
    end

    it do
      is_expected.to compile
      is_expected.to contain_cassandra__schema__table('users')
      is_expected.to contain_exec('/usr/bin/cqlsh   -e "CREATE TABLE IF NOT EXISTS Excelsior.users (userid text, username FROZEN<fullname>, emails set<text>, top_scores list<int>, todo map<timestamp, text>, tuple<int, text,text>, PRIMARY KEY (userid)) WITH COMPACT STORAGE AND ID=\'5a1c395e-b41f-11e5-9f22-ba0be0483c18\'" localhost 9042')
    end
  end

  context 'Drop Table' do
    let :facts do
      {
        operatingsystemmajrelease: 7,
        osfamily: 'RedHat'
      }
    end

    let(:title) { 'users' }

    let(:params) do
      {
        keyspace: 'Excelsior',
        ensure: 'absent'
      }
    end

    it do
      is_expected.to compile
      is_expected.to contain_exec('/usr/bin/cqlsh   -e "DROP TABLE IF EXISTS Excelsior.users" localhost 9042')
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

require 'spec_helper'

# check if rpcbind installed
describe package('rpcbind'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

# check if nfs server installed
describe package('nfs-kernel-server'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe service('nfs-kernel-server'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

# check if /etc/exports exist
describe file('/etc/exports'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end


require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'chrony', :type => 'class' do
  describe 'using defaults' do
    context 'on redhat' do
      let(:facts){
        {
          :osfamily => 'RedHat'
        }
      }
      it { should compile.with_all_deps }
      it { should_not contain_file('/etc/chrony.conf').with_content(/^allow/) }
      it { should contain_file('/etc/chrony.conf').with_content(/^port 0$/) }
    it { should contain_file('/etc/chrony.conf').with_content(/^local stratum 10$/) }
    it { should contain_file('/etc/chrony.conf').with_content(/^stratumweight 0$/) }
      it { should contain_file('/etc/chrony.conf').with_content(/^makestep 0.5 3$/) }
      ['0.pool.ntp.org', '1.pool.ntp.org', '2.pool.ntp.org'].each do |s|
        it { should contain_file('/etc/chrony.conf').with_content(/^server #{s} iburst$/) }
      end
      it { should contain_file('/etc/chrony.keys').with_mode('0640') }
      it { should contain_file('/etc/chrony.keys').with_owner('0') }
      it { should contain_file('/etc/chrony.keys').with_group('chrony') }
      it { should contain_file('/etc/chrony.keys').with_replace(true) }
      it { should contain_file('/etc/chrony.keys').with_content("0 xyzzy\n") }
    end

    context 'on archlinux' do
      let(:facts){
        {
          :osfamily => 'Archlinux'
        }
      }
      it { should compile.with_all_deps }
      it { should_not contain_file('/etc/chrony.conf').with_content(/^allow/) }
      it { should contain_file('/etc/chrony.conf').with_content(/^port 0$/) }
      ['0.pool.ntp.org', '1.pool.ntp.org', '2.pool.ntp.org'].each do |s|
        it { should contain_file('/etc/chrony.conf').with_content(/^server #{s} iburst$/) }
      end
      it { should contain_file('/etc/chrony.keys').with_mode('0644') }
      it { should contain_file('/etc/chrony.keys').with_owner('0') }
      it { should contain_file('/etc/chrony.keys').with_group('0') }
    end

    context 'on debian' do
      let(:facts){
        {
          :osfamily => 'Debian'
        }
      }
      it { should compile.with_all_deps }
      it { should_not contain_file('/etc/chrony/chrony.conf').with_content(/^allow/) }
      it { should contain_file('/etc/chrony/chrony.conf').with_content(/^port 0$/) }
    it { should contain_file('/etc/chrony/chrony.conf').with_content(/^local stratum 10$/) }
    it { should contain_file('/etc/chrony/chrony.conf').with_content(/^stratumweight 0$/) }
      it { should contain_file('/etc/chrony/chrony.conf').with_content(/^makestep 0.5 3$/) }
      ['0.pool.ntp.org', '1.pool.ntp.org', '2.pool.ntp.org'].each do |s|
        it { should contain_file('/etc/chrony/chrony.conf').with_content(/^server #{s} iburst$/) }
      end
      it { should contain_file('/etc/chrony/chrony.keys').with_mode('0640') }
      it { should contain_file('/etc/chrony/chrony.keys').with_owner('0') }
      it { should contain_file('/etc/chrony/chrony.keys').with_group('chrony') }
      it { should contain_file('/etc/chrony/chrony.keys').with_replace(true) }
      it { should contain_file('/etc/chrony/chrony.keys').with_content("0 xyzzy\n") }
    end

  end
  context 'on redhat with params' do
    let(:facts){
      {
        :osfamily => 'RedHat'
      }
    }
    let(:params){
      {
        :queryhosts => ['192.168/16' ],
        :port => '123',
        :makestep => '5 3',
        :stratumweight      => '0.005',
        :local_stratum      => '5',
        :config_keys_mode   => '0123',
        :config_keys_owner  => 'steve',
        :config_keys_group  => 'mrt',      
        :config_keys_manage => true,      
        :chrony_password    => 'sunny',
      }
    }
    it { should contain_file('/etc/chrony.conf').with_content(/^port 123$/) }
    it { should contain_file('/etc/chrony.conf').with_content(/^makestep 5 3$/) }
    it { should contain_file('/etc/chrony.conf').with_content(/^local stratum 5$/) }
    it { should contain_file('/etc/chrony.conf').with_content(/^stratumweight 0.005$/) }
    it { should contain_file('/etc/chrony.conf').with_content(/^allow 192\.168\/16$/) }
    it { should contain_file('/etc/chrony.keys').with_mode('0123') }
    it { should contain_file('/etc/chrony.keys').with_owner('steve') }
    it { should contain_file('/etc/chrony.keys').with_group('mrt') }
    it { should contain_file('/etc/chrony.keys').with_replace(true) }
    it { should contain_file('/etc/chrony.keys').with_content("0 sunny\n") }
  end
  context 'on redhat with queryhosts set to string any' do
    let(:facts){
      {
        :osfamily => 'RedHat'
      }
    }
    let(:params){
      {
        :queryhosts => 'aNy',
      }
    }
    it { should contain_file('/etc/chrony.conf').with_content(/^allow $/) }
  end
  context 'on redhat with queryhosts set to array with content any' do
    let(:facts){
      {
        :osfamily => 'RedHat'
      }
    }
    let(:params){
      {
        :queryhosts => ['195.168/16', 'ANY'],
      }
    }
    it { should contain_file('/etc/chrony.conf').with_content(/^allow $/) }
    it { should_not contain_file('/etc/chrony.conf').with_content(/195\.168\/16/) }
  end
  context 'on redhat with an unmanaged chrony.keys file' do
    let(:facts){
      {
        :osfamily => 'RedHat'
      }
    }
    let(:params){
      {
        :config_keys_manage => false,      
        :chrony_password    => 'unset',
      }
    }
    it { should contain_file('/etc/chrony.keys').with_replace(false) }
    it { should contain_file('/etc/chrony.keys').with_content("") }
  end
  context 'on redhat with an unmanaged chrony.keys file and password' do
    let(:facts){
      {
        :osfamily => 'RedHat'
      }
    }
    let(:params){
      {
        :config_keys_manage => false,      
      }
    }
    it { expect {
      should compile
    }.to raise_error(/Setting \$config_keys_manage false and \$chrony_password at same time in chrony is not possible\./) }
  end
  context 'on debian with params' do
    let(:facts){
      {
        :osfamily => 'Debian'
      }
    }
    let(:params){
      {
        :queryhosts => ['192.168/16' ],
        :port => '123',
        :makestep => '5 3',
        :stratumweight      => '0.005',
        :local_stratum      => '5',
        :config_keys_mode   => '0123',
        :config_keys_owner  => 'steve',
        :config_keys_group  => 'mrt',
        :config_keys_manage => true,
        :chrony_password    => 'sunny',
      }
    }
    it { should contain_file('/etc/chrony.conf').with_content(/^port 123$/) }
    it { should contain_file('/etc/chrony/chrony.conf').with_content(/^makestep 5 3$/) }
    it { should contain_file('/etc/chrony/chrony.conf').with_content(/^local stratum 5$/) }
    it { should contain_file('/etc/chrony/chrony.conf').with_content(/^stratumweight 0.005$/) }
    it { should contain_file('/etc/chrony/chrony.conf').with_content(/^allow 192\.168\/16$/) }
    it { should contain_file('/etc/chrony/chrony.keys').with_mode('0123') }
    it { should contain_file('/etc/chrony/chrony.keys').with_owner('steve') }
    it { should contain_file('/etc/chrony/chrony.keys').with_group('mrt') }
    it { should contain_file('/etc/chrony/chrony.keys').with_replace(true) }
    it { should contain_file('/etc/chrony/chrony.keys').with_content("0 sunny\n") }
  end
  context 'on debian with queryhosts set to string any' do
    let(:facts){
      {
        :osfamily => 'Debian'
      }
    }
    let(:params){
      {
        :queryhosts => 'aNy',
      }
    }
    it { should contain_file('/etc/chrony/chrony.conf').with_content(/^allow $/) }
  end
  context 'on debian with queryhosts set to array with content any' do
    let(:facts){
      {
        :osfamily => 'Debian'
      }
    }
    let(:params){
      {
        :queryhosts => ['195.168/16', 'ANY'],
      }
    }
    it { should contain_file('/etc/chrony/chrony.conf').with_content(/^allow $/) }
    it { should_not contain_file('/etc/chrony/chrony.conf').with_content(/195\.168\/16/) }
  end
    context 'on debian with an unmanaged chrony.keys file' do
    let(:facts){
      {
        :osfamily => 'Debian'
      }
    }
    let(:params){
      {
        :config_keys_manage => false,
        :chrony_password    => 'unset',
      }
    }
    it { should contain_file('/etc/chrony/chrony.keys').with_replace(false) }
    it { should contain_file('/etc/chrony/chrony.keys').with_content("") }
  end
  context 'on debian with an unmanaged chrony.keys file and password' do
    let(:facts){
      {
        :osfamily => 'Debian'
      }
    }
    let(:params){
      {
        :config_keys_manage => false,
      }
    }
    it { expect {
      should compile
    }.to raise_error(/Setting \$config_keys_manage false and \$chrony_password at same time in chrony is not possible\./) }
  end
  context 'on any other system' do
    let(:facts){
      {
        :osfamily => 'Debian',
      }
    }
    it { expect {
      should compile
    }.to raise_error(/The chrony module is not supported on an Debian based system\./) }
  end
end


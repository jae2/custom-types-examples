Puppet::Type.type(:custom_package).provide(:brew) do

  CUSTOM_ENVIRONMENT = { "HOME" => ENV["HOME"], "USER" => ENV["USER"] }
  confine :osfamily     => :darwin
  has_command :brew,'brew' do
    environment CUSTOM_ENVIRONMENT
  end


  def self.instances
    packages = brew('list')
    packages.split("\n").collect do |name|
      Puppet.debug("name -> #{name}")
       new(:name => name, :ensure => :present)
    end
  end
  def self.prefetch (resources)
    packages = instances
    resources.keys.each do |name|
      if provider = packages.find { |pkg| pkg.name == name }

         Puppet.debug("name -> #{name}")
         resources[name].provider = provider
      end
    end
  end


  def exists?
      @property_hash[:ensure] == :present
  end

  def create
    brew('install', '--force', resource[:name])
  end

  def destroy
    brew('uninstall', resource[:name])
  end

end


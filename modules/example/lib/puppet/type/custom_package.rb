Puppet::Type.newtype(:custom_package) do
  ensurable
  feature :versionable, "Package manager interrogate and return software version."

  validate do
    fail ('source is required when ensure is present') if self[:ensure] == 'present' and self[:source].nil?
  end

  autorequire(:file) do
    self[:source] if self[:source] and Pathname.new(self[:source]).absolute?
  end

  newparam(:name, :namevar => true) do

  end


  newparam(:source) do
    validate do |value|
      unless Pathname.new(value).absolute? ||
             URI.parse(value).is_a?(URI::HTTP)
        fail ("Invalid source #{value}")
      end
    end
  end

  newparam(:replace_config) do
    defaultto :no
    newvalues(:yes,:no)
  end

  newproperty(:version, :required_features => :versionable) do
    validate do |value|
      fail("Invalid version #{value}") unless value =~ /^[0-9A-Za-z\.-]+$/
    end
  end
end


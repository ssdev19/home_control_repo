Facter.add('chassis_type_custom') do
    confine :osfamily => :windows
    setcode do
      'testvalue'
    end
  end
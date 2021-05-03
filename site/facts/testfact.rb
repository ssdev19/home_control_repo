Facter.add('test_fact') do
    confine :osfamily => :windows
    setcode do
      'test_fact_value'
    end
  end
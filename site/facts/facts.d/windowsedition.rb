Facter.add('windows_edition_custom') do
  confine :osfamily => :windows
  setcode do
    'testvalue'
  end
end
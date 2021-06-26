Facter.add('windows_edition_custom') do
  confine :osfamily => :windows
  setcode do
    value = nil
    Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Microsoft\Windows NT\CurrentVersion') do |regkey|
      value = 'build: '+regkey['CurrentBuild'], 'Edition: '+regkey['EditionID'], "Product: "+regkey['ProductName']
      value2 = 
    end
    value
  end
end
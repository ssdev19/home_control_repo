Facter.add('windows_edition_custom') do
  confine :osfamily => :windows
  setcode do
    value = nil
    Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Microsoft\Windows NT\CurrentVersion') do |regkey|
      edition = regkey['EditionID'],
      build = regkey['CurrentBuild']
    end
    value
  end
end
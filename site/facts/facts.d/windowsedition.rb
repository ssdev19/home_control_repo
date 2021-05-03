Facter.add('windows_edition_custom') do
  confine :osfamily => :windows
  setcode do
    value = nil
    Win32::Registry::.open('HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion') do |regkey|
      value = regkey['EditionID']
    end
    value
  end
end
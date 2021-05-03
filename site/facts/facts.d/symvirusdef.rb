Facter.add('symantec_virus_definition') do
    confine :osfamily => :windows
    setcode do
      value = nil
      Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Symantec\Symantec Endpoint Protection\CurrentVersion\Public-Opstate') do |regkey|
        value = regkey['LatestVirusDefsDate'],
        value2 = regkey['LatestVirusDefsRevision']
      end
      value
    end
  end
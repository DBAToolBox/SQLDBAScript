# This script replaces all emails from the text file with the specified and then replaces all duplications

$ITSemail = 'address@mail.com' #mail address to be replaced



(Get-Content "D:\Backup\stored_procs_$(get-date -f yyyy-MM-dd).sql") | 
Foreach-Object {$_ -replace "\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]+\b",$ITSemail} | 

Foreach-Object {$_ -replace "$ITSemail;$ITSemaill;$ITSemail",$ITSemail} |
Foreach-Object {$_ -replace "$ITSemail,$ITSemaill,$ITSemail",$ITSemail} |

Foreach-Object {$_ -replace "$ITSemail $ITSemail",$ITSemail} |
Foreach-Object {$_ -replace "$ITSemail;$ITSemail",$ITSemail} |
Foreach-Object {$_ -replace "$ITSemail,$ITSemail",$ITSemail} |

Foreach-Object {$_ -replace "$ITSemail(;|,)",$ITSemail} |
Foreach-Object {$_ -replace "(;|,)$ITSemail",$ITSemail} |

Foreach-Object {$_ -replace "$ITSemail$ITSemail$ITSemail",$ITSemail} |
Foreach-Object {$_ -replace "$ITSemail$ITSemail",$ITSemail} |

Foreach-Object {$_ -replace "$ITSemail $ITSemaill $ITSemail",$ITSemail} |
Foreach-Object {$_ -replace "$ITSemail~$ITSemail",$ITSemail} |

#Foreach-Object {$_ -replace "\/(\*\*\*\*\*\*).*\r?",''} |

Foreach-Object {$_ -replace "CREATE\s+PROCEDURE","ALTER PROCEDURE"} |
Foreach-Object {$_ -replace "CREATE\s+PROC","ALTER PROCEDURE"} |

Out-File "D:\Backup\modified_stored_procs_$(get-date -f yyyy-MM-dd)_ITS.sql"

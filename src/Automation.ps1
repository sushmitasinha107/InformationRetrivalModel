
$counter = 0
$v = ""

$fileName = ""
$command = ""
#---------------DFR--------------------------
$basicModel = ("Be","G","P","D","I(n)","I(ne)","I(F)")
$afterEffect = ("L","B","none")
$normalization = ("H1","H2","H3","Z","none")
foreach($model in $basicModel){
    foreach($Effect in $afterEffect){
        foreach($norm in $normalization){
            $v =  ($model + "," + $Effect + "," + $norm + "," + ++$counter)
            $xmlLocation = "C:\Solr\server\solr\IR_3\conf"
            cd $xmlLocation
            $xml = [xml](Get-Content '.\managed-schema')
            $xml.schema.similarity.ChildNodes[0].InnerText = $model
            $xml.schema.similarity.ChildNodes[1].InnerText = $Effect
            $xml.schema.similarity.ChildNodes[2].InnerText = $norm
            $xml.Save("{0}\\managed-schema" -f ($xmlLocation))
            $solrLocation = "C:\Solr\bin"
            cd $solrLocation
            Start-Process "cmd.exe" "/c solr restart -p 8983"
            Start-Sleep -Seconds 20
            Stop-Process -Name conhost -Force
            cd "C:\Users\Mohammad Abuzar\Anaconda3"
            $fileName = "DFR_Test_"+$counter+".txt"
            $command = ("/c python TEST.py " + $fileName)
            start-process "cmd.exe" $command
            Start-Sleep -Seconds 2
            Write-Host $v
        }
    }
}


#-----------------------BM25---------------------------------
$k1 = (1.2,1.25,1.3,1.35,1.4,1.45,1.5,1.55,1.6,1.65,1.7,1.75,1.8,1.85,1.9,1.95,2.0)
$bList = (0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.85,0.9)
foreach($k in $k1){
    foreach($b in $bList){ 
        $v =  (($k).ToString() + "," + ($b).ToString() + "," + (++$counter).ToString())
        Write-Host $v
        $xmlLocation = "C:\Solr\server\solr\IR_3\conf"
        cd $xmlLocation
        $xml = [xml](Get-Content '.\managed-schema')
        $xml.schema.similarity.ChildNodes[0].InnerText = $k
        $xml.schema.similarity.ChildNodes[1].InnerText = $b
        $xml.Save("{0}\\managed-schema" -f ($xmlLocation))
        $solrLocation = "C:\Solr\bin"
        cd $solrLocation
        Start-Process "cmd.exe" "/c solr restart -p 8983"
        Start-Sleep -Seconds 20
        Stop-Process -Name conhost -Force
        cd "C:\Users\Mohammad Abuzar\Anaconda3"
        $fileName = "BM25_Test_"+$counter+".txt"
        $command = ("/c python TEST.py " + $fileName)
        start-process "cmd.exe" $command
        Start-Sleep -Seconds 2       
    }
}

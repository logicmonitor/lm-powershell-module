function New-LMDeviceGroupFromPath {
    param (
        [String]$Path,

        [String]$PreviousGroupId
    )
    
    if ($PreviousGroupId) {
        $GroupId = (Get-LMDeviceGroup -Filter "name -eq '$Path' -and parentId -eq '$PreviousGroupId'").Id
        if (!$GroupId) {
            $GroupId = (New-LMDeviceGroup -Name $Path -ParentGroupId $PreviousGroupId).Id
        }
        return $GroupId
    }
    else {
        $GroupId = (Get-LMDeviceGroup -Filter "name -eq '$Path' -and parentId -eq '1'").Id
        if (!$GroupId) {
            $GroupId = (New-LMDeviceGroup -Name $Path -ParentGroupId 1).Id
        }
        return $GroupId
    }
}

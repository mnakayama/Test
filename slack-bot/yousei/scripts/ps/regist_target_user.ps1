chcp 65001 | Out-Null

function GetUid($slack_id) {
    $sql = "SET NOCOUNT ON;select uid from rogue..add_item_target_user_mapping where slack_id = '" + $slack_id + "';"
    $result = sqlcmd -U name -P password -S db  -Q $sql

    if ($result[2] -eq $Null) {
        return -1;
    }

    $uid = $result[2].Trim()

    if ($uid -eq "") {
        return -1;
    }

    return $uid
}

function Check($targetUid) {
    $sql = "SET NOCOUNT ON;select uid from rogue..add_item_target_user where uid = " + $targetUid + ";"
    $result = sqlcmd -U name -P password -S db  -Q $sql

    if ($result[2] -ne $Null) {
        return -1;
    }

    # �Ώۂ̃A�C�e����S�Ď擾
    $equipIds = @()

    $sql2 = "SET NOCOUNT ON;select top(1) equip_id from rogue..item_user_recovery_master where getdate() between from_date and to_date;"
    $result2 = sqlcmd -U name -P password -S db  -Q $sql2

    for ($i = 2; $i -lt $result2.Length; $i++) {
        $value = $result2[$i].Trim()
        if ($value -ne $Null) {
            $equipIds += $value
        }
    }
    
    if ($equipIds.Length -eq 0) {
        return -2
    }

    # history�ɑ΂��āAequipId��1���`�F�b�N
    # 1�ł��t�^�̂�̂�����Γo�^����
    # (�o�b�`���Ŗ��t�^�̂�̂����t�^����̂ő��v)
    $allGet = $TRUE
    foreach ($equipId in $equipIds) {
        $sql3 = "SET NOCOUNT ON;select * from rogue..add_item_target_user_history where uid = " + $targetUid + " and equip_id = " + $equipId + ";"
        $result3 = sqlcmd -U name -P password -S db  -Q $sql3

        if ($result3[2] -eq $Null) {
            $allGet = $FALSE
            break
        }

        if ($result3[2].Trim() -eq $Null) {
            $allGet = $FALSE
            break
        }
    }

    if ($allGet -eq $TRUE) {
        return -3;
    }

    return 0;
}

function Regist($targetUid) {
    $sql = "insert into rogue..add_item_target_user values(" + $targetUid + ", getdate())"
    sqlcmd -U name -P password -S db  -Q $sql
}

$slack_id = $args[0]
$uid = GetUid($slack_id)

$checkResult = Check($uid)
if ($checkResult -eq -1) {
    return "���ɓo�^�ς݂���"
} elseif ($checkResult -eq -2) {
    return "�t�^�ł���A�C�e�����Ȃ���"
} elseif ($checkResult -eq -3) {
    return "���ɕt�^�ς݂���"
} elseif ($checkResult -ne 0) {
    return "�G���[������������[" + $checkResult + "]"
}

if ($uid -eq -1) {
    return "add_item_target_user_mapping�ɃA�J�E���g��o�^����"
}

$ret = Regist($uid)
return "�o�^������"
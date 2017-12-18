chcp 65001 | Out-Null
# U4K6NR1RD : 61411698
$slack_id = $args[0]

function CheckAccount() {
    $sql = "SET NOCOUNT ON;select uid from rogue..add_item_target_user_mapping where slack_id = '" + $slack_id + "';"
    $result = sqlcmd -U name -P password -S db -Q $sql

    if ($result[2] -eq $Null) {
        return "add_item_target_user_mapping�ɃA�J�E���g��o�^����";
    }

    $uid = $result[2].Trim()

    if ($uid -eq "") {
        return "add_item_target_user_mapping�ɃA�J�E���g��o�^����";
    }

    $sql = "SET NOCOUNT ON;select nickname from rogue..platform_userinfo with (nolock) where uid = " + $uid
    $result = sqlcmd -U name -P password -S db -Q $sql

    if ($result[2] -eq $Null) {
        return "platform_userinfo��uid[" + $uid + "]�����݂��Ȃ���"
    }
    
    $nick = $result[2].Trim()

    if ($nick -eq "") {
        return "platform_userinfo�̏�񂪕s������ uid[" + $uid + "]"
    }

    return "���݂̖��O��uid[" + $uid + "], nick[" + $nick + "]����"
}

$ret = CheckAccount
return $ret

chcp 65001 | Out-Null

# param
$slack_id = $args[0]
$slack_account = $args[1]
$uid = $args[2]

function Add() {

    if (($slack_id -eq $Null) -Or ($slack_id -eq "")) {
        return "slack_id���s������"
    }

    $sql = "SET NOCOUNT ON;select nickname from rogue..platform_userinfo with (nolock) where uid = " + $uid
    $result = sqlcmd -U name -P password -S db  -Q $sql

    if ($result[2] -eq $Null) {
        return "platform_userinfo��uid[" + $uid + "]�����݂��Ȃ���"
    }
    
    $nick = $result[2].Trim()

    if ($nick -eq "") {
        return "platform_userinfo�̏�񂪕s������ uid[" + $uid + "]"
    }

    $sql = "SET NOCOUNT ON;select uid from rogue..add_item_target_user_mapping where slack_id = '" + $slack_id + "';"
    $result = sqlcmd -U name -P password -S db  -Q $sql
    
    if ($result[2] -ne $Null) {
        return "���ɓo�^����Ă����Buid[" + $uid + "], nick[" + $nick + "]";
    }

    $sql = "insert rogue..add_item_target_user_mapping values('" + $slack_id + "','" + $slack_account + "'," + $uid + ",getdate())"
    $result = sqlcmd -U name -P password -S db  -Q $sql

    return "uid[" + $uid + "], nick[" + $nick + "]�̃A�J�E���g��o�^������"
}

$ret = Add
return $ret
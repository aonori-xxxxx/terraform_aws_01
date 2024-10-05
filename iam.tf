# - - - - - - - - - - - - - -
# iam Role
# - - - - - - - - - - - - - -

resource "aws_iam_instance_profile" "ec2_profile" {
  name = aws_iam_role.ec2_iam_role.name
  role = aws_iam_role.ec2_iam_role.name
}

#ロール
resource "aws_iam_role" "ec2_iam_role" {
  name               = "${var.project}-ec2-iam-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

#IAM信頼ポリシー　※webコンソールだと自動的に作成される内容
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ec2_iam_role_ssm_managed" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
# Role
resource "aws_iam_role" "cert-manager-solver-role" {
  name = var.cert_manager_solver_role_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.node_group_role_arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Policy
resource "aws_iam_policy" "policy" {
  name        = "cert-manager-solver-role"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "route53:GetChange",
            "Resource": "arn:aws:route53:::change/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets",
                "route53:ListResourceRecordSets"
            ],
            "Resource": "arn:aws:route53:::hostedzone/${var.hosted_zone_id}"
        }
    ]
}
POLICY
}

# bind policy to role
resource "aws_iam_role_policy_attachment" "cer_role-cert_policy" {
  policy_arn = aws_iam_policy.policy.arn
  role       = aws_iam_role.cert-manager-solver-role.name
}
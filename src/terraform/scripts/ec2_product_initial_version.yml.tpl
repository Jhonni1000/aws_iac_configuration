AWSTemplateFormatVersion: "2010-09-09"
Description: "EC2 SSM-managed instance Initial Version"

Parameters:
  InstanceType:
    Type: String
    Default: t2.micro
  KeyName:
    Type: AWS::EC2::KeyPair::KeyName

Resources:
  MyEC2:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: "ami-0c4fc5dcabc9df21d"
      InstanceType: !Ref InstanceType
      IamInstanceProfile: !Ref EC2SSMInstanceProfile
      KeyName: !Ref KeyName
      UserData:
        Fn::Base64: !Sub |
          #!/bin/bash
          sudo apt update && sudo apt upgrade -y
          sudo apt install -y git jq curl

  EC2SSMInstanceProfile:
    Type: AWS::IAM::InstanceProfile
    Properties:
      Roles:
        - !Ref EC2SSMRole

  EC2SSMRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: ec2.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
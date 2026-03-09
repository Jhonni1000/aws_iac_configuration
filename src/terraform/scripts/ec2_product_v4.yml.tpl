---
AWSTemplateFormatVersion: "2010-09-09"
Description: "EC2 SSM-managed instance"

Parameters:
  VPCConfig:
    Type: AWS::EC2::VPC::Id
    Description: Select a VPC

  SubnetCfg:
    Type: AWS::EC2::Subnet::Id
    Description: Select a Subnet

  EC2Storage:
    Type: Number
    Default: 30
    AllowedValues:
      - 30
      - 50
      - 70
      - 100
    Description: Select Data Disk Size. Defaults to 30GB 

  InstanceType:
    Type: String
    Default: t3.micro
    AllowedValues:
      - t3.micro
      - t3.small
      - t3.medium
      - t3.large
      
Resources:
  MyEC2:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: "{{resolve:ssm:/amis/ec2/ubuntu_ami}}"
      SubnetId: !Ref SubnetCfg
      InstanceType: !Ref InstanceType
      IamInstanceProfile: !Ref EC2SSMInstanceProfile
      BlockDeviceMappings:
        - DeviceName: /dev/xvda
          Ebs:
            VolumeSize: 20
            VolumeType: gp3
            Encrypted: true
        - DeviceName: /dev/sdf
          Ebs:
            VolumeSize: !Ref EC2Storage
            VolumeType: gp3
            Encrypted: true
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

Outputs:
  InstanceId:
    Description: EC2 Instance ID
    Value: !Ref MyEC2
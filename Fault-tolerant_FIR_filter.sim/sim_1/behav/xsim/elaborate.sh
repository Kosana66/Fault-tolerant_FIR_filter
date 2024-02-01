#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2020.2 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Thu Feb 01 19:38:36 CET 2024
# SW Build 3064766 on Wed Nov 18 09:12:47 MST 2020
#
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# elaborate design
echo "xelab -wto 2f070c9a827841edb39cb8b8f38c67b1 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot switch_tb_behav xil_defaultlib.switch_tb -log elaborate.log"
xelab -wto 2f070c9a827841edb39cb8b8f38c67b1 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot switch_tb_behav xil_defaultlib.switch_tb -log elaborate.log


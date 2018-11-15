#!/usr/bin/env python3

import argparse
import os
from junit_xml import TestSuite, TestCase

def generate_junit_xml(inputfile):
    target = None
    suite = None
    infos = []
    errors = []
    testcases = []

    for line in inputfile:
        tag = line[0:3]
        props = line[3:].split(':')
        if tag == "[!]":
            if len(props) == 2:
                if props[0].strip().lower() == "target":
                    target = os.path.basename(props[1].strip())
                elif props[0].strip().lower() == "group":
                    suite = props[1].strip()
                else:
                    infos.append(line)
            else:
                infos.append(line)
        if tag == "[x]":
            errors.append(line)
        if tag == "[+]":
            testcases.append(TestCase(name=props[0].strip(), classname=target, stdout=line))
        if tag == "[-]":
            tc = TestCase(name=props[0].strip(), classname=target)
            tc.add_failure_info(message=props[1].strip(), output=line, failure_type="failed")
            testcases.append(tc)

    ts = TestSuite(name=suite, test_cases=testcases, stdout="\n".join(infos), stderr="\n".join(errors))
    return TestSuite.to_xml_string([ts])


if __name__ == "__main__":
    ap = argparse.ArgumentParser(add_help=True)
    ap.add_argument("-o", "--out", default=None, help="Output file.")
    ap.add_argument("input", help="input file")

    args = ap.parse_args()

    if args.input is None:
        print("Input file reqired")
        ap.print_usage()
        exit()

    with open(args.input, "r") as ifile:
        if args.out != None:
            with open(args.out, "w") as ofile:
                ofile.write(generate_junit_xml(ifile))
        else:
            print(generate_junit_xml(ifile))

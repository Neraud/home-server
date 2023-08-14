import argparse
import os
import json
import sys
import yaml
from yaml.loader import SafeLoader

parser = argparse.ArgumentParser(description='Process some integers.')

parser.add_argument('--in', '-i', nargs='?', dest='in_folder', required=True, help='Folder containing the images to build')
parser.add_argument('--out', '-o', nargs='?', dest='out_file', help='Target JSON file to write the results')

args = parser.parse_args()
images_to_build = []


if os.path.exists(args.in_folder):
    print(f'Looking for images to build under {args.in_folder}')

    for f in [ f.name for f in os.scandir(args.in_folder) if f.is_dir() ]:
        print(f' - {f}')
        vars_file_path = os.path.join(args.in_folder, f, 'vars.yaml')
        if os.path.exists(vars_file_path):
            with open(vars_file_path) as yf:
                data = yaml.load(yf, Loader=SafeLoader)
                print(data)
                image_to_build = {
                    "folder": f,
                    "image_name": data["image_name"],
                    "image_tag": data["image_tag"],
                }
                images_to_build.append(image_to_build)
        else:
            print('Missing {vars_file_path} !')
            sys.exit(1)
else:
    print(f'In folder {args.in_folder} doesn\'t exist, nothing to build')


print('')

images_json = json.dumps(images_to_build, indent=2)
print('Images found :')
print(images_json)

print('')

if args.out_file:
    print(f'Writing output to {args.out_file}')
    with open(args.out_file, "w") as of:
        of.write(images_json)

#!/usr/bin/env python3

import os
import glob
from shutil import copyfile
import xmltodict

sourceRootFolder = "/config-source"
targetRootFolder = "/config-target"

targetConfigFolder = targetRootFolder + "/config"
targetPluginsFolder = targetRootFolder + "/plugins/configurations"


def handleOneFile(sourceFile):
  print("**************************************************")
  print("From %s" % sourceFile)
  sourceFileName = os.path.basename(sourceFile)

  if sourceFileName.startswith('plugins_'):
    targetFile = targetPluginsFolder + '/' + sourceFileName[8:]
  else:
    targetFile = targetConfigFolder + '/' + sourceFileName
  print("To %s" % targetFile)

  if os.path.exists(targetFile):
    print("Merging configurations")
    mergeXmlFile(sourceFile, targetFile)
  else:
    print("Target doesn't exist, copying the input file")
    copyfile(sourceFile, targetFile)


def mergeXmlFile(sourceFile, targetFile):
  with open(sourceFile) as sourceFileFd, open(targetFile) as targetFileFd:
    sourceDoc = xmltodict.parse(sourceFileFd.read())
    targetDoc = xmltodict.parse(targetFileFd.read())
    topLevel = list(sourceDoc.keys())[0]

    if topLevel not in targetDoc:
      raise Exception("Top level '%s' not in target document" % topLevel)

    targetDoc[topLevel] = mergeXmlContent(targetDoc[topLevel], sourceDoc[topLevel], [topLevel])

  with open(targetFile, 'w') as targetFileFd:
    print("Writing updated target file")
    targetFileFd.write(xmltodict.unparse(targetDoc, pretty=True))


def mergeXmlContent(target, source, path=None):
  if path is None: path = []
  print(path)
  for key in source:
    if key.startswith('@'):
      continue
    if key in target:
      if isinstance(target[key], dict) and isinstance(source[key], dict):
        mergeXmlContent(target[key], source[key], path + [str(key)])
      elif target[key] == source[key]:
        print(" - %s.%s : %s (unchanged)" % ('.'.join(path), key, source[key]))
        pass
      else:
        print(" - %s.%s : %s -> %s" % ('.'.join(path), key, target[key], source[key]))
        target[key] = source[key]
    else:
      print(" - %s.%s : [not defined] -> %s" % ('.'.join(path), key, source[key]))
      target[key] = source[key]
  return target


if not os.path.exists(targetConfigFolder):
  print("Creating missing config dir")
  os.makedirs(targetConfigFolder)

if not os.path.exists(targetPluginsFolder):
  print("Creating missing plugins config dir")
  os.makedirs(targetPluginsFolder)

print("Searching for xml files in %s" % sourceRootFolder)
for sourceFile in glob.glob(sourceRootFolder + "/*.xml"):
  handleOneFile(sourceFile)

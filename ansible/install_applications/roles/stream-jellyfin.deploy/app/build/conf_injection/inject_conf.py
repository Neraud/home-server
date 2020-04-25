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
    mergeXml(sourceFile, targetFile)
  else:
    print("Target doesn't exist, copying the input file")
    copyfile(sourceFile, targetFile)

def mergeXml(sourceFile, targetFile):
  targetUpdated = False
  with open(sourceFile) as sourceFileFd, open(targetFile) as targetFileFd:
    sourceDoc = xmltodict.parse(sourceFileFd.read())
    targetDoc = xmltodict.parse(targetFileFd.read())
    topLevel = list(sourceDoc.keys())[0]
    
    if topLevel not in targetDoc:
      raise Exception("Top level '%s' not in target document" % topLevel)

    for propertyName in sourceDoc[topLevel].keys():
      if propertyName.startswith('@'):
        continue

      propertyValueSource = sourceDoc[topLevel][propertyName]
      if propertyName in targetDoc[topLevel]:
        propertyValueTarget = targetDoc[topLevel][propertyName]
      else:
        propertyValueTarget = "[not set]"
      
      if propertyValueSource != propertyValueTarget:
        targetUpdated = True
        print(" - %s : %s -> %s" % (propertyName, propertyValueTarget, propertyValueSource))
        targetDoc[topLevel][propertyName] = propertyValueSource
      else:
        print(" - %s : %s (unchanged)" % (propertyName, propertyValueSource))
  
  if targetUpdated:
    with open(targetFile, 'w') as targetFileFd:
      print("Writing updated target file")
      targetFileFd.write(xmltodict.unparse(targetDoc, pretty=True))


if not os.path.exists(targetConfigFolder):
  print("Creating missing config dir")
  os.makedirs(targetConfigFolder)

if not os.path.exists(targetPluginsFolder):
  print("Creating missing plugins config dir")
  os.makedirs(targetPluginsFolder)

print("Searching for xml files in %s" % sourceRootFolder)
for sourceFile in glob.glob(sourceRootFolder + "/*.xml"):
  handleOneFile(sourceFile)

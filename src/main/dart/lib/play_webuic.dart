library play_webuic;

import 'dart:async';
import 'dart:io';


import "package:web_ui/dwc.dart" as dwc;
import "package:web_ui/src/options.dart";
import "package:web_ui/src/compiler.dart";

void main() {
  
  var o = new Options();
  
  var co = CompilerOptions.parse(o.arguments);
  
  dwc.run(o.arguments).then((result) {
    if(result.success){
      dumpDependencies(co.outputDir, co.inputFile, result.inputs, result.outputs);
    }else{
      exit(1);
    }
  });
}

IOSink openOutputStream(String outputDir, String entryPointPath, String type){
  int i = entryPointPath.lastIndexOf("/");
  String entryPoint;
  if(i==-1)
    entryPoint = entryPointPath;
  else
    entryPoint = entryPointPath.substring(i+1);
  return new File(outputDir + "/" + entryPoint + "." + type).openWrite();
}

Future dumpDependencies(String outputDir, String entryPoint, List deps, Map<String, String> outputs){
  IOSink depsStream = openOutputStream(outputDir,entryPoint, "deps");
  deps.forEach((d){
    File dep = new File(d);
    depsStream.write("file://" + dep.fullPathSync() + "\n");
  });
  
  depsStream.close();
  
  IOSink outsStream = openOutputStream(outputDir,entryPoint, "outs");
  outputs.forEach((k,v){
    File path = new File(k);
    outsStream.write("file://" + path.fullPathSync() + "\n");
  });
  outsStream.close();
  
}

function taskStartup(task)
  c = com.mathworks.util.ClassLoaderBridge.findClass("com.mathworks.toolbox.distcomp.pmode.SessionConstants");
  f = c.getField("sLAB_CONNECT_TIMEOUT");
  f.set([], java.lang.Integer(960000)); % Increase timeout to 16 minutes
end
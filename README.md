Lazy_API_with_HTML
==================
Lazy API with HTML (LAH) provides function to get data out of HTMLs, and shape them into structures like dictionary or array. It consists of xml liked script and the interpreter to interpret.

LAH script is designed to be directly perceived through the senses. For instance:
    <a href=some_struct_declare_before>
then you can get the value of attribute href later.

Other two features may make LAH easier to be used:

1) All downloads are complete in delegate, LAH just responses to tell when and from where to download. You can implement your own delegate. Like me, I implemented one with MKNetworkKit.

2) You can get data from more than one HTML files by organise them in the structure declare part of the script. In common, it is a tree like structure.

To understand more, view the demo.

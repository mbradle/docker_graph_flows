# docker_graph_flows
This is the Webnucleo network flow code docker image repository.

# Steps to build and run the default docker image.

First clone the repository.  Type:

**git clone http://github.com/mbradle/docker_graph_flows**

Now change into the cloned directory.  Type:

**cd docker_graph_flows**

If you have previously cloned the repository, you can update by typing:

**git pull**

Now build the image.  Type:

**docker build -t flow_grapher:default .**

The docker image that gets built is *flow_grapher:default*.  The *:default* is a tag that allows you to distinguish other flow grapher images.  Of course you can provide your own name for both the image and the tag.

Now create a directory for the input and output.  Type:

**mkdir work**

**mkdir work/input**

**mkdir work/output**

**cp input/run.rsp work/input/**

Now get the data file from which you will graph the flows.  This could be, for example, the output from running a [single_zone docker](https://github.com/mbradle/docker_single_zone/blob/master/README.md) containter.
Place the xml file you will use in the *work/output* directory with the name *input.xml*.  For example, copy the *docker_single_zone/work/output/out.xml* you obtained from the single-zone docker container you built
to *work/input/input.xml* in *docker_graph_flows*.

Now note the answer to typing

**pwd**

In the instructions below, you should simply be able to use the commands verbatim (most likely, you will simply cut and paste).  If that does not work, replace the *$PWD* present with the string that is returned by the *pwd* command.  
Now edit *work/input/run.rsp*.  Run the calculation.  For example, type:

**docker run -it -v $PWD/work/input:/input_directory -v $PWD/work/output:/output_directory -e VAR=@/input_directory/run.rsp flow_grapher:default**

The output will a number of *dot*, *tex*, and *pdf* files in the directory *work/output/flows*.  One can edit the response file and/or add options.  For example, to only create flow diagrams for
the first 30 timesteps in the calculation recorded in *input.xml*, type:

**docker run -it -v $PWD/work/input:/input_directory -v $PWD/work/output:/output_directory -e VAR="@/input_directory/run.rsp --zone_xpath '"'[position() <= 30]'"'" flow_grapher:default**

Linux users may find they need to prepend *sudo* to run docker.  For example, they may need to type:

**sudo docker run -it -v $PWD/work/input/data_pub:/data_directory -e VAR=data webnucleo/data_download**

Here are some [notes](https://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo) on running without *sudo* that may be of interest.

# Steps to list possible options or an example execution.

To get a help statement for a flow grapher docker image, type:

**docker run -e VAR=--help flow_grapher:default**

The output lists a usage statement for the underlying network graph flow code.  Any of the suggested commands can be entered as input through the *VAR* variable.  For example, you can type:

**docker run -e VAR=--example flow_grapher:default**

to get the example execution (of the underlying network graph flows code).  The options in the example execution would be added to the response file or the command line (through *VAR*).  To get the listing of all possible options, type:

**docker run -e VAR="--prog all" flow_grapher:default**

The input to *VAR* is between quotes to ensure that it is recognized as a single input string.  To get options for a particular class, select that class as input to the *program_options* option.  For example, type:

**docker run -e VAR="--prog network_grapher" flow_grapher:default**

# Steps to build with a different master.h file.

First, it's useful to prune any dangling containers by typing:

**docker system prune**

The command

**docker system prune -a**

will clear out everything and start over if you prefer.

Next, download the default *master.h* to the *$PWD* directory.  Type:

**docker run -it -v $PWD:/header_directory -e HEADER_COPY_DIRECTORY=/header_directory flow_grapher:default**

Edit *master.h*.  Now rebuild, but set the WN_USER flag:

**docker build -t flow_grapher:tag --build-arg WN_USER=1 .**

where *tag* is a tag to distinguish the new image from the default.  

# How to force a rebuild of one of your images.

If you suspect that the underlying code has been updated since your latest docker build, you can force a rebuild by using the *--no-cache* option.  For example, you can type:

**docker build --no-cache -t flow_grapher:default .**

This will force docker to pull any new changes to the underlying codes down before rebuilding.

# Using Docker Hub for your images.

Once you have an image that you would like to share with your collaborators, you can set up a repository on [Docker Hub](https://hub.docker.com).  You can push images to the repository that others can then pull down and use.  This [site](https://runnable.com/docker/using-docker-hub) provides more information.

"""A profile with two bare metal CentOS7 connected by a LAN.

Instructions:
Wait for the profile instance to start, and then log in to either machine via the
ssh ports specified below.
"""

import geni.portal as portal
import geni.rspec.pg as rspec

# Create a portal context, needed to defined parameters
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = portal.context.makeRequestRSpec()

# Optional physical type for all nodes.
pc.defineParameter("phystype",  "Optional physical node type",
                   portal.ParameterType.STRING, "",
                   longDescription="Specify a physical node type (pc3000,d710,etc) " +
                   "instead of letting the resource mapper choose for you.")

# Retrieve the values the user specifies during instantiation.
params = pc.bindParameters()

pc.verifyParameters()


# Create two nodes.
node1 = request.RawPC("node1")
node2 = request.RawPC("node2")
node1.disk_image = 'urn:publicid:IDN+emulab.net+image+emulab-ops//CENTOS7-64-STD'
node2.disk_image = 'urn:publicid:IDN+emulab.net+image+emulab-ops//CENTOS7-64-STD'

# Optional hardware type.
if params.phystype != "":
    node1.hardware_type = params.phystype
    node2.hardware_type = params.phystype

# Create interfaces for each node.
iface1 = node1.addInterface("if1")
iface2 = node2.addInterface("if2")

# Create a link with the type of LAN.
link = request.LAN("lan")

# Add both node interfaces to the link.
link.addInterface(iface1)
link.addInterface(iface2)

# Install and execute a script that is contained in the repository.
node2.addService(rspec.Execute(shell="bash", command="/local/repository/node2.sh"))

node1.addService(rspec.Execute(shell="bash", command="/local/repository/node1.sh"))

portal.context.printRequestRSpec()

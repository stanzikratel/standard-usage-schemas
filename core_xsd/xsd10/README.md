XSD 1.0 Core Schema
===================

This directory contains XSD 1.0 versions of the core event/usage
XSDs. These XSDs are non-normative, that is to say, these are not the
XSDs that will be used for validation.

The normative XSDs are the ones in the parent directory, they are
based on the XSD 1.1 standard, and contain many business assertions
not found in these XSDs.

The XSDs found in this directory are meant to be consumed by tools
like JAX-B which currently do not have support for XSD 1.1.

**DO NOT USE THE XSDs IN THIS DIRECTORY FOR VALIDATION**

If you need to do XSD 1.1 validation, there are currently two tools
available:

1. Xerecs: Is an OpenSource Java implementation, with command line
   utilities etc. We have a patched version which incorporates many bug
   fixes.  You can find it here:
   https://github.com/RackerWilliams/xercesj

   If you use maven, you can pull it in from here:

   ```xml
   <dependency>
     <groupId>xerces</groupId>
     <artifactId>xerces-xsd11</artifactId>
     <version>2.12.0-rax</version>
   </dependency>
   ```

   ```xml
   <repository>
     <id>rackspace-research</id>
     <name>Rackspace Research Repository</name>
     <url>http://maven.research.rackspacecloud.com/content/groups/public/</url>
   </repository>
   ```

2. Saxon: A proprietary tool, it is significantly faster than Xerces.

   If you use maven, you can pull it from here:

   ```xml
   <dependency>
      <groupId>net.sf.saxon</groupId>
      <artifactId>saxon-ee</artifactId>
      <version>9.4.0.4</version>
   </dependency>
   ```

   ```xml
   <repository>
      <id>rackspace-research</id>
      <name>Rackspace Research Repository</name>
      <url>http://maven.research.rackspacecloud.com/content/groups/public/</url>
   </repository>
   ```

   Saxon is proprietary and therefore requires a license. Rackspace
   has a site license for Saxon. Contact Jesse Gonzalez for details.

    
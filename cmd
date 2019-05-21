using System;
using System.Diagnostics;

namespace WinGo
{
    public static class Terminal
    {
        public static string Cmd( string cmd )
        {
            try
            {
                using ( Process proc = new Process() )
                {
                    proc.StartInfo.FileName = Environment.GetEnvironmentVariable( "systemroot" ) + "\\system32\\cmd.exe";
                    if ( cmd.Contains( "`" ) )
                        cmd = cmd.Replace( '`', '"' );
                    proc.StartInfo.Arguments = "/c " + cmd;
                    proc.StartInfo.RedirectStandardOutput = true;
                    proc.StartInfo.RedirectStandardError = true;
                    proc.StartInfo.UseShellExecute = false;
                    proc.Start();
                    string result = "";
                    while ( true )
                    {
                        if ( proc.StandardError.Peek() != -1 )
                        {
                            while ( !proc.StandardError.EndOfStream )
                            {
                                result += proc.StandardError.ReadLine() + "\r\n";
                            }
                            break;
                        }
                        else
                        {
                            if ( proc.StandardOutput.Peek() != -1 )
                            {
                                while ( !proc.StandardOutput.EndOfStream )
                                {
                                    result += proc.StandardOutput.ReadLine() + "\r\n";
                                }
                                break;
                            }
                        }
                    }
                    proc.WaitForExit( 15000 );
                    return result;
                }
            }
            catch ( Exception ex )
            {
                return ex.ToString();
            }
        }
        public static void Main()
        {

        }
    }
}

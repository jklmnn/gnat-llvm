------------------------------------------------------------------------------
--                             G N A T - L L V M                            --
--                                                                          --
--                     Copyright (C) 2013-2018, AdaCore                     --
--                                                                          --
-- This is free software;  you can redistribute it  and/or modify it  under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  This software is distributed in the hope  that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License for  more details.  You should have  received  a copy of the GNU --
-- General  Public  License  distributed  with  this  software;   see  file --
-- COPYING3.  If not, go to http://www.gnu.org/licenses for a complete copy --
-- of the license.                                                          --
------------------------------------------------------------------------------

with Atree;    use Atree;
with Namet;    use Namet;
with Sinput;   use Sinput;

with GNATLLVM.GLValue; use GNATLLVM.GLValue;
with GNATLLVM.Wrapper; use GNATLLVM.Wrapper;

package body GNATLLVM.DebugInfo is

   --------------------------
   -- Initialize_Debugging --
   --------------------------

   procedure Initialize_Debugging (Env : Environ) is
   begin
      if Emit_Debug_Info then
         Env.DIBld := Create_Debug_Builder (Env.Mdl);
         Env.Debug_Compile_Unit :=
           Create_Debug_Compile_Unit
           (Env.DIBld, Get_Debug_File_Node (Env, Main_Source_File));
      end if;
   end Initialize_Debugging;

   ------------------------
   -- Finalize_Debugging --
   ------------------------

   procedure Finalize_Debugging (Env : Environ) is
   begin
      if Emit_Debug_Info then
         Finalize_Debug_Info (Env.DIBld);
      end if;
   end Finalize_Debugging;

   -------------------------
   -- Get_Debug_File_Node --
   -------------------------

   function Get_Debug_File_Node
     (Env : Environ; File : Source_File_Index) return Metadata_T is
   begin
      if DI_Cache = null then
         DI_Cache :=
           new DI_File_Cache'(1 .. Last_Source_File => No_Metadata_T);
      end if;

      if DI_Cache (File) /= No_Metadata_T then
         return DI_Cache (File);
      end if;

      declare
         Full_Name : constant String :=
           Get_Name_String (Full_Debug_Name (File));
         Name      : constant String :=
           Get_Name_String (Debug_Source_Name (File));
         DIFile    : constant Metadata_T :=
           Create_Debug_File (Env.DIBld, Name,
                              Full_Name (1 .. Full_Name'Length - Name'Length));
      begin
         DI_Cache (File) := DIFile;
         return DIFile;
      end;
   end Get_Debug_File_Node;

   ----------------------------------
   -- Create_Subprogram_Debug_Info --
   ----------------------------------

   function Create_Subprogram_Debug_Info
     (Env            : Environ;
      Func           : GL_Value;
      Def_Ident      : Entity_Id;
      N              : Node_Id;
      Name, Ext_Name : String) return Metadata_T
   is
      pragma Unreferenced (Def_Ident);
   begin
      if Emit_Debug_Info then
         return Create_Debug_Subprogram
           (Env.DIBld,
            LLVM_Value (Func),
            Get_Debug_File_Node (Env, Get_Source_File_Index (Sloc (N))),
            Name, Ext_Name, Integer (Get_Logical_Line_Number (Sloc (N))));
      else
         return No_Metadata_T;
      end if;
   end Create_Subprogram_Debug_Info;

   ---------------------------
   -- Set_Debug_Pos_At_Node --
   ---------------------------

   procedure Set_Debug_Pos_At_Node (Env : Environ; N : Node_Id) is
   begin
      if Emit_Debug_Info then
         Set_Debug_Loc (Env.Bld, Env.Func_Debug_Info,
                        Integer (Get_Logical_Line_Number (Sloc (N))),
                        Integer (Get_Column_Number (Sloc (N))));
      end if;
   end Set_Debug_Pos_At_Node;

end GNATLLVM.DebugInfo;

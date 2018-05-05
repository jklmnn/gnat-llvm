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

with Sinfo;    use Sinfo;

with GNATLLVM.GLValue;     use GNATLLVM.GLValue;

package GNATLLVM.Variables is

   procedure Detect_Duplicate_Global_Names;
   --  Make a pass over all library units looking for the use of the same
   --  global name in two different entities and keep a record of all such
   --  duplications.

   procedure Emit_Declaration (N : Node_Id)
     with Pre => Nkind_In (N, N_Object_Declaration, N_Exception_Declaration);
   --  Emit a declaration

   procedure Emit_Object_Renaming_Declaration (N : Node_Id)
     with Pre => Nkind (N) = N_Object_Renaming_Declaration;
   --  Emit an object renaming declaration

   function Emit_Identifier_LValue (N : Node_Id) return GL_Value
     with Pre => Nkind_In (N, N_Identifier, N_Expanded_Name, N_Operator_Symbol,
                           N_Defining_Identifier, N_Defining_Operator_Symbol);
   --  Evaluate an N_Identifier and similar to obtain an LValue

   function Emit_Identifier_Value (N : Node_Id) return GL_Value
     with Pre => Nkind_In (N, N_Identifier, N_Expanded_Name,
                           N_Operator_Symbol);
   --  Evaluate an N_Identifier and similar to obtain an LValue

end GNATLLVM.Variables;
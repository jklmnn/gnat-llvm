with Types; use Types;

with LLVM.Core; use LLVM.Core;

with GNATLLVM.Environment; use GNATLLVM.Environment;
with Atree; use Atree;
with Einfo; use Einfo;

package GNATLLVM.Types is

   type Type_Array is array (Nat range <>) of Type_T;

   procedure Register_Builtin_Types (Env : Environ);

   function Create_Access_Type
     (Env : Environ; TE : Entity_Id) return Type_T
     with Pre => Is_Type (TE);
   --  Function that creates the access type for a corresponding type. Since
   --  access types are not just pointers, this is the abstraction bridge
   --  between the two. For the moment, it handles array accesses and thin
   --  (normal) accesses.

   function Create_Array_Bounds_Type
     (Env             : Environ;
      Array_Type_Node : Entity_Id) return Type_T;
   --  Helper that returns the type used to store array bounds. This is a
   --  structure that that follows the following pattern: { LB0, UB0, LB1,
   --  UB1, ... }

   function Create_Subprogram_Type_From_Spec
     (Env       : Environ;
      Subp_Spec : Node_Id) return Type_T;

   function Create_Subprogram_Type_From_Entity
     (Env           : Environ;
      Subp_Type_Ent : Entity_Id) return Type_T;

   function Create_Type (Env : Environ; TE : Entity_Id) return Type_T
     with Pre => Is_Type (TE);

   procedure Create_Discrete_Type
     (Env       : Environ;
      TE        : Entity_Id;
      TL        : out Type_T;
      Low, High : out Value_T)
     with Pre => Ekind (TE) in Discrete_Kind;

   function Int_Ty (Num_Bits : Natural) return Type_T;
   function Fn_Ty (Param_Ty : Type_Array; Ret_Ty : Type_T) return Type_T;

   function Get_Innermost_Component_Type
     (Env : Environ; N : Entity_Id) return Type_T;

   function Get_Address_Type return Type_T;

end GNATLLVM.Types;

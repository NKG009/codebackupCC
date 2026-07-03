public Class CheckRecursionTOE{
    private static boolean run = true;
    public static boolean runOnce(){
    if(run){
     run=false;
     return true;
    }else{
        return run;
    }
    }
      private static boolean run2 = true;
    public static boolean runOnce2(){
    if(run2){
     run2=false;
     return true;
    }else{
        return run2;
    }
    }
}
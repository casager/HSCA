public class rfaTo64{
    public static void main(String[] args) {
        int j = 0;
        int k = 0;
        for (int i = 0; i < 64; i++){
           System.out.printf("rfa rfa%d(a[%d], b[%d], c%d, sum[%d], g[%d], p[%d]);%n", i,i,i,i,i,i,i);
            if (i%4 == 3){
                    System.out.printf("bclg4 bclg%d(c%d, g[%d:%d], p[%d:%d], gout[%d], pout[%d], c%d, c%d, c%d);", j,i-3, i, i-3, i, i-3, j, j, i-2, i-1, i);
                   // System.out.println();
                    System.out.println();
                    System.out.println();
                    j++;
            }
            if (i % 16 == 15){
                System.out.printf("bclg4 bclgLevel2_%d(c%d, gout[%d:%d], pout[%d:%d], gout2[%d], pout2[%d], c%d, c%d, c%d);", k,i-15, j-1, j-4, j-1, j-4, k, k, i-11, i-7, i-3);
                System.out.println();
                System.out.println();
                k++;
                //bclg4 bclgLevel2_1(c0, gout[3:0], pout[3:0], gout2[0], pout2[0], c4, c8, c12);
            }
            // System.out.printf("c%d", i); //used for generating list of c values
            // if (i % 16 == 15){
            //     System.out.println(";");
            // }
            // else System.out.print(", ");
        }
    }
}
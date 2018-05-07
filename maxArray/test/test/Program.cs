namespace test
{
    using System;

    public class Program
    {
        public static int FindMax(int[] arr)
        {
            int max = arr[0];
            int maxi = 0;
            for (var i = 1; i < arr.Length; i++)
            {
                if (max < arr[i])
                {
                    max = arr[i];
                    maxi = i;
                }
            }

            return maxi;
        }

        public static void Main()
        {
            Random rand = new Random();
            int[] arr = new int[10];
            for (var i = 0; i < 10; i++)
            {
                arr[i] = rand.Next(20);
            }

            int maxi = FindMax(arr);
            for (var i = 0; i < 10; i++)
            {
                Console.WriteLine("arr[{0}] = {1}", i, arr[i]);
            }

            Console.WriteLine("index max - {0}", maxi);
            Console.ReadLine();
        }
    }
}

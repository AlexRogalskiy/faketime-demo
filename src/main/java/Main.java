import java.util.Date;

public class Main {

    //simple main with synchronized main to be
    //able to wait and count to show that faked time is passing
    public static void main(String[] args) throws InterruptedException {
        Main main = new Main();
        for (int i = 0; i < 5; i++) {
            System.out.println("Hello world! Today is:" + new Date());
            synchronized (main) {
                main.wait(1000);
            }
        }
    }

}

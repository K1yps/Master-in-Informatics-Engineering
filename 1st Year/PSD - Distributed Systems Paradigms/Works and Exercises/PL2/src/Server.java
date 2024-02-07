import java.io.IOException;
import java.net.SocketAddress;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.nio.channels.spi.SelectorProvider;
import java.util.function.Function;

public class Server implements Runnable {

    public ServerSocketChannel ss = ServerSocketChannel.open();
    Selector global_sel = SelectorProvider.provider().openSelector();

    public Server(SocketAddress address) throws IOException {
        ss.bind(address);
        ss.configureBlocking(false);
        ss.register(global_sel, SelectionKey.OP_ACCEPT);
    }

    public void run() {
        while (true) {
            try {
                global_sel.select();
                for (SelectionKey key : global_sel.selectedKeys()) {
                    if (key.isAcceptable()){
                        SocketChannel channel = ss.accept();
                        channel.configureBlocking(false);
                        channel.register(global_sel, SelectionKey.OP_READ);
                    }
                    else if (key.isReadable())
                        Function.identity(); // TODO : Work in proguess
                    else if (key.isReadable())
                        Function.identity(); // TODO : Work in proguess
                }
            } catch (IOException e) {
                System.err.println("You fucked up " + e);
                return;
            }
        }
    }

    public static void main(String[] args) throws IOException {
        //new Server().run();
    }
}

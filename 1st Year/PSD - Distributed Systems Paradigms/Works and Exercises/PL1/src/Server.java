import java.io.IOException;
import java.net.SocketAddress;
import java.nio.channels.SocketChannel;

public class Server {

    public SocketChannel channel = SocketChannel.open();

    public Server(SocketAddress address) throws IOException {
        channel.bind(address);
    }


    public static void main(String[] args) {


    }
}

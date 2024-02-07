import java.io.IOException;
import java.net.SocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;

public class Client {

    public SocketChannel channel = SocketChannel.open();


    public Client(SocketAddress server_address) throws IOException {
        channel.connect(server_address);
    }

    public void receive() {


    }

    public void send(int timeout, int buff_size) {
        ByteBuffer buff = ByteBuffer.allocate(buff_size);
        while (true) {

        }
    }

    public static void main(String[] args) {


    }


}

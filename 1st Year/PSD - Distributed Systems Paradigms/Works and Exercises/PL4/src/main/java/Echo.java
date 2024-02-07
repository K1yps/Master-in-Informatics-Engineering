import spullara.nio.channels.FutureServerSocketChannel;
import spullara.nio.channels.FutureSocketChannel;

import java.net.InetSocketAddress;
import java.nio.ByteBuffer;

public class Echo {

    public static void cicle(FutureSocketChannel s) {
        final var bb = ByteBuffer.allocate(128);
        s.read(bb).thenCompose(n -> {
            return s.write(bb);
        }).thenRun(() -> cicle(s));

    }

    public static void fds(FutureSocketChannel s) {
        s.write(ByteBuffer.wrap(Thread.currentThread().toString().getBytes())).thenRun(() -> fds(s));
    }

    public static void main(String[] args) throws Exception {
        var ss = new FutureServerSocketChannel();

        ss.bind(new InetSocketAddress("127.0.0.1", 8888));

        ss.accept().thenAccept(Echo::cicle);

    }
}
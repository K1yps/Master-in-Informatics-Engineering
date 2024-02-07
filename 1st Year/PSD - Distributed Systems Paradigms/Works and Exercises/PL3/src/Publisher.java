import java.nio.ByteBuffer;

public interface Publisher {

    void onNext(ByteBuffer data);

    void onError();

    void onComplete();

    void subscribe();

    void request();

    void cancel();
}

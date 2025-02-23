import kotlinx.coroutines.*
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import com.chatsopond.kmp.model.VehicleStatus

interface VehicleObserverDelegate {
    fun vehicleObserver(observer: VehicleObserver, vehicleId: String, status: VehicleStatus)
}

class VehicleObserver {
    private val mutex = Mutex()
    private val scope = CoroutineScope(Dispatchers.Default)
    private val jobs = mutableMapOf<String, Job>()

    var delegate: VehicleObserverDelegate? = null

    suspend fun observe(vehicleId: String) {
        mutex.withLock {
            if (jobs.containsKey(vehicleId)) return

            val job = scope.launch {
                while (isActive) {
                    val status = VehicleStatus(
                        vehicleId,
                        (10..100).random(),
                        (0..120).random()
                    )
                    delegate?.vehicleObserver(this@VehicleObserver, vehicleId, status)
                    delay(1200)
                }
            }

            jobs[vehicleId] = job
        }
    }

    suspend fun stopObserving(vehicleId: String) {
        mutex.withLock {
            jobs[vehicleId]?.cancel()
            jobs.remove(vehicleId)
        }
    }

    suspend fun stopObservingAll() = withContext(Dispatchers.Default) {
        mutex.withLock {
            jobs.values.forEach { it.cancel() }
            jobs.clear()
        }
    }
}
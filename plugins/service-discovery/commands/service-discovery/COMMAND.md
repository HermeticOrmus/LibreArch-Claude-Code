# /service-discovery

> Design service registry topology, configure health checks, debug DNS resolution failures, and choose between client-side and server-side discovery.

## Usage

```
/service-discovery design      - Choose discovery pattern (Kubernetes, Consul, Eureka)
/service-discovery health      - Design liveness, readiness, and startup health checks
/service-discovery debug       - Diagnose DNS resolution failures or stale registry entries
/service-discovery configure   - Generate Kubernetes Service YAML or Consul service definition
```

## Trigger

Use this command when:
- Setting up service-to-service communication in a new microservice deployment
- Configuring health checks that correctly gate traffic (readiness) vs restart (liveness)
- Debugging a service that cannot resolve another service's hostname
- Choosing between Consul service mesh and Kubernetes native discovery
- Services are connecting to stale IPs after pod restarts

## Process

### /service-discovery design
1. Identify the infrastructure: Kubernetes cluster? Bare-metal? Multi-cloud?
2. For Kubernetes: use Kubernetes Services (ClusterIP) — built-in, no external dependency.
3. For bare-metal or hybrid: use Consul with DNS interface and health checks.
4. For legacy Spring Boot: Eureka is acceptable but prefer Kubernetes-native when on K8s.
5. Define the DNS naming convention (namespace-aware for Kubernetes).

### /service-discovery health
1. Separate liveness from readiness: liveness = process alive, readiness = ready for traffic.
2. Liveness check: minimal — ping endpoint, thread pool alive. No remote calls.
3. Readiness check: database connection, critical downstream services.
4. Add startup probe for slow-starting services (JVMs with large classpaths).
5. Set appropriate timeouts: liveness timeout = 2s, readiness timeout = 5s.
6. Test health checks under dependency failure: liveness should NOT fail when downstream is down.

### /service-discovery debug
1. Test DNS resolution from inside the pod:
   `kubectl exec -it <pod> -- nslookup order-service.production.svc.cluster.local`
2. Check Service exists and has endpoints:
   `kubectl get endpoints order-service -n production`
3. Check if endpoints are populated (pods passing readiness):
   `kubectl describe endpoints order-service -n production`
4. Check CoreDNS pods are running:
   `kubectl get pods -n kube-system -l k8s-app=kube-dns`
5. For Consul: `consul catalog services`, `consul health service order-service`

### /service-discovery configure
1. Generate Kubernetes Service YAML with appropriate type (ClusterIP, LoadBalancer, ExternalName).
2. Add readiness and liveness probes to Deployment spec.
3. For Consul: generate service definition HCL with health check and TTL.
4. For external services: generate ExternalName service for stable DNS alias.

## Examples

**Example: `/service-discovery debug`**

Symptom: "order-service can't connect to inventory-service. Getting connection refused."

Debug sequence:
```bash
# 1. Test DNS from inside order-service pod
kubectl exec -n production deploy/order-service -- \
  nslookup inventory-service.production.svc.cluster.local
# Expected: resolves to ClusterIP (e.g., 10.96.100.45)
# If NXDOMAIN: Service doesn't exist or wrong namespace

# 2. Check if Service exists
kubectl get svc inventory-service -n production
# Expected: ClusterIP 10.96.100.45, port 80

# 3. Check endpoints — are any pods healthy?
kubectl get endpoints inventory-service -n production
# Expected: ENDPOINTS contains pod IPs
# If empty: all pods failing readiness check

# 4. If endpoints empty — check pod readiness
kubectl describe pod -l app=inventory-service -n production | grep -A5 Readiness
# Check what the readiness probe is checking and why it fails

# 5. Check readiness endpoint directly from inside the cluster
kubectl exec -n production deploy/order-service -- \
  curl -s http://inventory-service.production/actuator/health/readiness
```

**Example: `/service-discovery configure`**

Input: "Need to expose order-service internally within cluster and inventory-service externally to the internet via HTTPS."

Output:
```yaml
# order-service — internal only
apiVersion: v1
kind: Service
metadata:
  name: order-service
  namespace: production
spec:
  selector:
    app: order-service
  ports:
    - port: 80
      targetPort: 8080
  type: ClusterIP
# DNS: order-service.production.svc.cluster.local

---
# inventory-service — external HTTPS via AWS NLB
apiVersion: v1
kind: Service
metadata:
  name: inventory-service
  namespace: production
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "external"
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
spec:
  selector:
    app: inventory-service
  ports:
    - port: 443
      targetPort: 8443
  type: LoadBalancer
```

## Output Format

- Discovery pattern recommendation with justification
- Kubernetes Service YAML or Consul service definition HCL
- Health check endpoint design (what each check verifies)
- Debug command sequence for DNS, endpoint, and readiness failures
- Common failure modes with diagnostic commands

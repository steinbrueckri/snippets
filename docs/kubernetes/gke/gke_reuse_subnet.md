# GKE reuse Subnetwork in Interconnect Context

## Backround Infos:
https://cloud.google.com/interconnect/docs/how-to/dedicated/using-interconnects-other-projects#targetText=In%20a%20Shared%20VPC%20scenario,the%20Shared%20VPC%20host%20project.
https://console.cloud.google.com/support/cases/detail/19527106?organizationId=792607166204&supportedpurview=project

```sh
Error: Error applying plan:

1 error occurred:

* module.k8s.google_container_cluster.cluster: 1 error occurred:
* google_container_cluster.cluster: Error waiting for creating GKE cluster: Retry budget exhausted (10 attempts): Services range "sn-w1-3021-svc" in network "gc-4509-work", subnetwork "sn-w1-3021" is already used by another cluster.
```

**Google Support**
Hello,

I have received news from the Kubernetes engineering team that would solve this issue.

After some investigations the team believes that the cause is that a metadata entry created by GKE in "v135-4509-interconnect-work" project was not properly cleaned up upon cluster deletion. The kind of metadata entry is created for the purpose of reserving IP ranges to ensure clusters don't collide with each other.

To mitigate the issue, you will need to manually delete this metadata entry in project "v135-4509-interconnect-work":

```
Key                                     Value
gke-cluster-e86aa937-secondary-ranges   services:gc-4509-work:sn-w1-3016:sn-w1-3016-svc,shareable-pods:gc-4509-work:sn-w1-3016:sn-w1-3016-pod
```

The way to delete this key is by using the using the cloudshell command gcloud compute project-info remove-metadata[1].

Here is the custom command to delete that metadata key from the project:

$ gcloud compute project-info remove-metadata --keys=gke-cluster-e86aa937-secondary-ranges

After deleting this key, please try to recreate the cluster and I will check if it was correctly created without issue.

Also the team thinks that this metadata entry was leaked likely due to some internal issue upon previous cluster deletion. So the team is currently addressing this possible internal issue so it won get reproduced ever again.

We are so about the inconveniences.
I will be looking forward to your reply.
_______________
[1]: https://cloud.google.com/sdk/gcloud/reference/compute/project-info/remove-metadata

------------------------------------------------------------------------------------------------------------------------

gcloud config set project v135-4509-interconnect-work
gcloud compute project-info describe | grep 3021
    value: services:gc-4509-work:sn-w1-3021:sn-w1-3021-svc,shareable-pods:gc-4509-work:sn-w1-3021:sn-w1-3021-pod

    gcloud compute project-info describe
commonInstanceMetadata:
  fingerprint: E7v8KD-xhYg=
  items:
  - key: gke-cluster-1134128f-secondary-ranges
    value: services:gc-4509-work:sn-w1-3012:sn-w1-3012-svc,shareable-pods:gc-4509-work:sn-w1-3012:sn-w1-3012-pod
  - key: gke-cluster-147b063a-secondary-ranges
    value: services:gc-4509-work:sn-w1-3025:sn-w1-3025-svc,shareable-pods:gc-4509-work:sn-w1-3025:sn-w1-3025-pod
  - key: gke-cluster-2ef912fa-secondary-ranges
    value: services:gc-4509-work:sn-w1-3029:sn-w1-3029-svc,shareable-pods:gc-4509-work:sn-w1-3029:sn-w1-3029-pod
  - key: gke-cluster-37fc38c6-secondary-ranges
    value: services:gc-4509-work:sn-w1-3027:sn-w1-3027-svc,shareable-pods:gc-4509-work:sn-w1-3027:sn-w1-3027-pod
  - key: gke-cluster-4768433d-secondary-ranges
    value: services:gc-4509-work:sn-w1-3045:sn-w1-3045-svc,shareable-pods:gc-4509-work:sn-w1-3045:sn-w1-3045-pod
  - key: gke-cluster-52ade431-secondary-ranges
    value: services:gc-4509-work:sn-w1-3026:sn-w1-3026-svc,shareable-pods:gc-4509-work:sn-w1-3026:sn-w1-3026-pod
  - key: gke-cluster-5c7547f2-secondary-ranges
    value: services:gc-4509-work:sn-w1-3031:sn-w1-3031-svc,shareable-pods:gc-4509-work:sn-w1-3031:sn-w1-3031-pod
  - key: gke-cluster-5e0ca21e-secondary-ranges
    value: services:gc-4509-work:sn-w1-3036:sn-w1-3036-svc,shareable-pods:gc-4509-work:sn-w1-3036:sn-w1-3036-pod
  - key: gke-cluster-7529554a-secondary-ranges
    value: services:gc-4509-work:sn-w1-3024:sn-w1-3024-svc,shareable-pods:gc-4509-work:sn-w1-3024:sn-w1-3024-pod
  - key: gke-cluster-84bd42e0-secondary-ranges
    value: services:gc-4509-work:sn-w1-3035:sn-w1-3035-svc,shareable-pods:gc-4509-work:sn-w1-3035:sn-w1-3035-pod
  - key: gke-cluster-9df1725d-secondary-ranges
    value: services:gc-4509-work:sn-w1-3049:sn-w1-3049-svc,shareable-pods:gc-4509-work:sn-w1-3049:sn-w1-3049-pod
  - key: gke-cluster-a01b1e3f-secondary-ranges
    value: services:gc-4509-work:sn-w1-3019:sn-w1-3019-svc,shareable-pods:gc-4509-work:sn-w1-3019:sn-w1-3019-pod
  - key: gke-cluster-a1b94440-secondary-ranges
    value: services:gc-4509-work:sn-w1-3044:sn-w1-3044-svc,shareable-pods:gc-4509-work:sn-w1-3044:sn-w1-3044-pod
  - key: gke-cluster-a93b8556-secondary-ranges
    value: services:gc-4509-work:sn-w1-3009:sn-w1-3009-svc,shareable-pods:gc-4509-work:sn-w1-3009:sn-w1-3009-pod
  - key: gke-cluster-b839e91a-secondary-ranges
    value: services:gc-4509-work:sn-w1-3021:sn-w1-3021-svc,shareable-pods:gc-4509-work:sn-w1-3021:sn-w1-3021-pod
  - key: gke-cluster-bcb9e2f0-secondary-ranges
    value: services:gc-4509-work:sn-w1-3014:sn-w1-3014-svc,shareable-pods:gc-4509-work:sn-w1-3014:sn-w1-3014-pod
  - key: gke-cluster-bd6e7042-secondary-ranges
    value: services:gc-4509-work:sn-w1-3030:sn-w1-3030-svc,shareable-pods:gc-4509-work:sn-w1-3030:sn-w1-3030-pod
  - key: gke-cluster-c2923cc7-secondary-ranges
    value: services:gc-4509-work:sn-w1-3034:sn-w1-3034-svc,shareable-pods:gc-4509-work:sn-w1-3034:sn-w1-3034-pod
  - key: gke-cluster-ca556992-secondary-ranges
    value: services:gc-4509-work:sn-w1-3010:sn-w1-3010-svc,shareable-pods:gc-4509-work:sn-w1-3010:sn-w1-3010-pod
  - key: gke-cluster-d0dd441a-secondary-ranges
    value: services:gc-4509-work:sn-w1-3020:sn-w1-3020-svc,shareable-pods:gc-4509-work:sn-w1-3020:sn-w1-3020-pod
  - key: gke-cluster-d9c4c052-secondary-ranges
    value: services:gc-4509-work:sn-w1-3038:sn-w1-3038-svc,shareable-pods:gc-4509-work:sn-w1-3038:sn-w1-3038-pod
  - key: gke-cluster-e5b6d11a-secondary-ranges
    value: services:gc-4509-work:sn-w1-3011:sn-w1-3011-svc,shareable-pods:gc-4509-work:sn-w1-3011:sn-w1-3011-pod
  - key: gke-cluster-e6584050-secondary-ranges
    value: services:gc-4509-work:sn-w1-3047:sn-w1-3047-svc,shareable-pods:gc-4509-work:sn-w1-3047:sn-w1-3047-pod
  - key: gke-cluster-e6860a16-secondary-ranges
    value: services:gc-4509-work:sn-w1-3043:sn-w1-3043-svc,shareable-pods:gc-4509-work:sn-w1-3043:sn-w1-3043-pod
  - key: gke-cluster-eb105ace-secondary-ranges
    value: services:gc-4509-work:sn-w1-3018:sn-w1-3018-svc,shareable-pods:gc-4509-work:sn-w1-3018:sn-w1-3018-pod
  - key: gke-cluster-f52649ab-secondary-ranges
    value: services:gc-4509-work:sn-w1-3015:sn-w1-3015-svc,shareable-pods:gc-4509-work:sn-w1-3015:sn-w1-3015-pod
  - key: gke-ppx-c1-938d1b24-secondary-ranges
    value: services:gc-4509-work:sn-w2-3017:sn-w2-3017-svc,shareable-pods:gc-4509-work:sn-w2-3017:sn-w2-3017-pod
  - key: gke-cluster-ec661209-secondary-ranges
    value: services:gc-4509-work:sn-w1-3048:sn-w1-3048-svc,shareable-pods:gc-4509-work:sn-w1-3048:sn-w1-3048-pod
  - key: gke-cluster-65fb2eac-secondary-ranges
    value: services:gc-4509-work:sn-w1-3016:sn-w1-3016-svc,shareable-pods:gc-4509-work:sn-w1-3016:sn-w1-3016-pod
  - key: gke-cluster-ebb6b3a9-secondary-ranges
    value: services:gc-4509-work:sn-w1-3050:sn-w1-3050-svc,shareable-pods:gc-4509-work:sn-w1-3050:sn-w1-3050-pod
  - key: gke-cluster-62e2ed79-secondary-ranges
    value: services:gc-4509-work:sn-w1-3051:sn-w1-3051-svc,shareable-pods:gc-4509-work:sn-w1-3051:sn-w1-3051-pod
  - key: gke-cluster-7a0e8667-secondary-ranges
    value: services:gc-4509-work:sn-w1-3053:sn-w1-3053-svc,shareable-pods:gc-4509-work:sn-w1-3053:sn-w1-3053-pod
  - key: gke-cluster-bff89e9a-secondary-ranges
    value: services:gc-4509-work:sn-w1-3054:sn-w1-3054-svc,shareable-pods:gc-4509-work:sn-w1-3054:sn-w1-3054-pod
  - key: gke-cluster-ac83808c-secondary-ranges
    value: services:gc-4509-work:sn-w1-3055:sn-w1-3055-svc,shareable-pods:gc-4509-work:sn-w1-3055:sn-w1-3055-pod
  - key: gke-cluster-b01e48f9-secondary-ranges
    value: services:gc-4509-work:sn-w1-3033:sn-w1-3033-svc,shareable-pods:gc-4509-work:sn-w1-3033:sn-w1-3033-pod
  - key: gke-cluster-d80fd247-secondary-ranges
    value: services:gc-4509-work:sn-w1-3063:sn-w1-3063-svc,shareable-pods:gc-4509-work:sn-w1-3063:sn-w1-3063-pod
  - key: gke-cluster-6c3982cc-secondary-ranges
    value: services:gc-4509-work:sn-w1-3052:sn-w1-3052-svc,shareable-pods:gc-4509-work:sn-w1-3052:sn-w1-3052-pod
  - key: gke-cluster-1acad4d6-secondary-ranges
    value: services:gc-4509-work:sn-w1-3032:sn-w1-3032-svc,shareable-pods:gc-4509-work:sn-w1-3032:sn-w1-3032-pod
    kind: compute#metadata
creationTimestamp: '2018-09-14T03:35:07.837-07:00'
defaultNetworkTier: PREMIUM
defaultServiceAccount: 221613232453-compute@developer.gserviceaccount.com
id: '6568340908741636148'
kind: compute#project
name: v135-4509-interconnect-work
quotas:
- limit: 25000.0
  metric: SNAPSHOTS
  usage: 0.0
- limit: 50.0
  metric: NETWORKS
  usage: 1.0
- limit: 500.0
  metric: FIREWALLS
  usage: 217.0
- limit: 10000.0
  metric: IMAGES
  usage: 0.0
- limit: 700.0
  metric: STATIC_ADDRESSES
  usage: 0.0
- limit: 500.0
  metric: ROUTES
  usage: 166.0
- limit: 375.0
  metric: FORWARDING_RULES
  usage: 0.0
- limit: 1250.0
  metric: TARGET_POOLS
  usage: 0.0
- limit: 1250.0
  metric: HEALTH_CHECKS
  usage: 0.0
- limit: 2300.0
  metric: IN_USE_ADDRESSES
  usage: 0.0
- limit: 1250.0
  metric: TARGET_INSTANCES
  usage: 0.0
- limit: 250.0
  metric: TARGET_HTTP_PROXIES
  usage: 0.0
- limit: 250.0
  metric: URL_MAPS
  usage: 0.0
- limit: 75.0
  metric: BACKEND_SERVICES
  usage: 0.0
- limit: 2500.0
  metric: INSTANCE_TEMPLATES
  usage: 0.0
- limit: 125.0
  metric: TARGET_VPN_GATEWAYS
  usage: 0.0
- limit: 250.0
  metric: VPN_TUNNELS
  usage: 0.0
- limit: 75.0
  metric: BACKEND_BUCKETS
  usage: 0.0
- limit: 20.0
  metric: ROUTERS
  usage: 2.0
- limit: 250.0
  metric: TARGET_SSL_PROXIES
  usage: 0.0
- limit: 250.0
  metric: TARGET_HTTPS_PROXIES
  usage: 0.0
- limit: 250.0
  metric: SSL_CERTIFICATES
  usage: 0.0
- limit: 275.0
  metric: SUBNETWORKS
  usage: 55.0
- limit: 250.0
  metric: TARGET_TCP_PROXIES
  usage: 0.0
- limit: 10.0
  metric: SECURITY_POLICIES
  usage: 0.0
- limit: 200.0
  metric: SECURITY_POLICY_RULES
  usage: 0.0
- limit: 2500.0
  metric: NETWORK_ENDPOINT_GROUPS
  usage: 0.0
- limit: 6.0
  metric: INTERCONNECTS
  usage: 0.0
- limit: 5000.0
  metric: GLOBAL_INTERNAL_ADDRESSES
  usage: 1.0
- limit: 125.0
  metric: VPN_GATEWAYS
  usage: 0.0
- limit: 125.0
  metric: EXTERNAL_VPN_GATEWAYS
  usage: 0.0
selfLink: https://www.googleapis.com/compute/v1/projects/v135-4509-interconnect-work
xpnProjectStatus: HOST




gcloud compute project-info remove-metadata --keys gke-cluster-b839e91a-secondary-ranges


 ~  gcloud compute project-info remove-metadata --keys gke-cluster-b839e91a-secondary-ranges
Updated [https://www.googleapis.com/compute/v1/projects/v135-4509-interconnect-work].

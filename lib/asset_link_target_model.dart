class AssetLinkTargetModel {
  String namespace = '';
  String packageName = '';
  List<String> sha256CertFingerprints = [];

  AssetLinkTargetModel.fromJson(Map<String, dynamic> json) {
    namespace = json['namespace'];
    packageName = json['package_name'];
    sha256CertFingerprints.addAll(
      (json['sha256_cert_fingerprints'] as List).map((sha256CertFingerprint) => sha256CertFingerprint),
    );
  }
}

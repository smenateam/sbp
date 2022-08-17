/// Модель, которая содердит в себе всю необходимую ифнормацию приложения(Android)
class AssetLinkTargetModel {
  /// [namespace] - namespace приложения
  late final String namespace;

  /// [packageName] -packageName приложения
  late final String packageName;

  /// [sha256CertFingerprints] - список sha256 приложения
  List<String> sha256CertFingerprints = [];

  /// Получение данных из словаря
  AssetLinkTargetModel.fromJson(Map<String, dynamic> json) {
    namespace = json['namespace'] ?? '';
    packageName = json['package_name'] ?? '';
    sha256CertFingerprints.addAll(
      (json['sha256_cert_fingerprints'] as List)
          .map((sha256CertFingerprint) => sha256CertFingerprint),
    );
  }
}

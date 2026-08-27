<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Support\Str;

class Post extends Model
{
    use SoftDeletes;

    protected $fillable = ['titulo','slug','conteudo','category_id','user_id','ativo','publicado_em'];
    protected $casts = ['ativo' => 'boolean', 'publicado_em' => 'datetime'];
    protected $appends = ['resumo'];

    public function author(): BelongsTo { return $this->belongsTo(User::class, 'user_id'); }
    public function category(): BelongsTo { return $this->belongsTo(Category::class); }
    public function tags(): BelongsToMany { return $this->belongsToMany(Tag::class); }
    public function comments(): HasMany { return $this->hasMany(Comment::class); }

    public function scopeAtivos($q) { return $q->where('ativo', true); }
    public function getResumoAttribute() { return Str::limit($this->conteudo, 100); }
    protected function titulo(): Attribute {
        return Attribute::make(set: fn($v) => ucfirst($v));
    }
}
